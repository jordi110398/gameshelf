import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  // --------------------------------------------------
  // CORS / PREFLIGHT
  // --------------------------------------------------
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {
    // --------------------------------------------------
    // Client amb la sessió de l'usuari
    // --------------------------------------------------

    const supabaseUser = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      {
        global: {
          headers: {
            Authorization: req.headers.get("Authorization") ?? "",
          },
        },
      },
    );

    // Comprovem qui és l'usuari que fa la petició
    const {
      data: { user },
      error: userError,
    } = await supabaseUser.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({
          error: "Usuari no autenticat",
        }),
        {
          status: 401,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const userId = user.id;

    // --------------------------------------------------
    // Client administratiu amb la Service Role Key
    // --------------------------------------------------

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // --------------------------------------------------
    // 1. Eliminar avatar(s) de Storage
    // --------------------------------------------------

    const {
      data: files,
      error: listError,
    } = await supabaseAdmin.storage
      .from("avatars")
      .list(userId);

    if (listError) {
      console.error("Error llistant avatars:", listError);
    } else if (files && files.length > 0) {
      const filePaths = files.map(
        (file) => `${userId}/${file.name}`,
      );

      const {
        error: removeError,
      } = await supabaseAdmin.storage
        .from("avatars")
        .remove(filePaths);

      if (removeError) {
        console.error(
          "Error eliminant avatars:",
          removeError,
        );
      }
    }

    // --------------------------------------------------
    // 2. Eliminar l'usuari de Auth
    // --------------------------------------------------

    const {
      error: deleteError,
    } = await supabaseAdmin.auth.admin.deleteUser(userId);

    if (deleteError) {
      console.error(
        "Error eliminant usuari:",
        deleteError,
      );

      return new Response(
        JSON.stringify({
          error: "No s'ha pogut eliminar el compte",
        }),
        {
          status: 500,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // --------------------------------------------------
    // 3. Resposta correcta
    // --------------------------------------------------

    return new Response(
      JSON.stringify({
        success: true,
      }),
      {
        status: 200,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error("Error inesperat:", error);

    return new Response(
      JSON.stringify({
        error: "Error intern del servidor",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }
});