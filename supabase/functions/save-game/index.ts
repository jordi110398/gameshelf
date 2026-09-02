import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function isNonEmptyString(value: unknown, maxLength: number): boolean {
  return typeof value === "string" && value.trim().length > 0 &&
    value.length <= maxLength;
}

function isOptionalString(value: unknown, maxLength: number): boolean {
  return value === null || value === undefined ||
    (typeof value === "string" && value.length <= maxLength);
}

function isOptionalNonNegativeInt(value: unknown): boolean {
  return value === null || value === undefined ||
    (Number.isInteger(value) && (value as number) >= 0);
}

// --------------------------------------------------
// Validació del payload
// --------------------------------------------------

function validateGame(body: unknown): Record<string, unknown> | null {
  if (typeof body !== "object" || body === null) {
    return null;
  }

  const b = body as Record<string, unknown>;

  if (!Number.isInteger(b.igdb_id) || (b.igdb_id as number) <= 0) {
    return null;
  }

  if (!isNonEmptyString(b.title, 500)) {
    return null;
  }

  if (!isOptionalString(b.cover_url, 1000)) return null;
  if (!isOptionalString(b.artwork_url, 1000)) return null;
  if (!isOptionalString(b.summary, 5000)) return null;
  if (!isOptionalString(b.storyline, 5000)) return null;
  if (!isOptionalString(b.slug, 500)) return null;

  if (b.release_date !== null && b.release_date !== undefined) {
    if (typeof b.release_date !== "string" || isNaN(Date.parse(b.release_date))) {
      return null;
    }
  }

  if (b.rating !== null && b.rating !== undefined) {
    if (typeof b.rating !== "number" || b.rating < 0 || b.rating > 100) {
      return null;
    }
  }

  if (!isOptionalNonNegativeInt(b.rating_count)) return null;

  let genres: string[] = [];
  if (b.genres !== null && b.genres !== undefined) {
    if (!Array.isArray(b.genres) || !b.genres.every((g) => typeof g === "string")) {
      return null;
    }
    genres = b.genres as string[];
  }

  let platforms: string[] = [];
  if (b.platforms !== null && b.platforms !== undefined) {
    if (
      !Array.isArray(b.platforms) ||
      !b.platforms.every((p) => typeof p === "string")
    ) {
      return null;
    }
    platforms = b.platforms as string[];
  }

  // Objecte explícit: mai fem spread del body cru.
  return {
    igdb_id: b.igdb_id,
    title: (b.title as string).trim(),
    cover_url: b.cover_url ?? null,
    artwork_url: b.artwork_url ?? null,
    summary: b.summary ?? null,
    storyline: b.storyline ?? null,
    release_date: b.release_date ?? null,
    rating: b.rating ?? null,
    rating_count: b.rating_count ?? null,
    slug: b.slug ?? null,
    genres,
    platforms,
  };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
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

    const {
      data: { user },
      error: userError,
    } = await supabaseUser.auth.getUser();

    if (userError || !user) {
      return jsonResponse({ error: "Usuari no autenticat" }, 401);
    }

    // --------------------------------------------------
    // Validació
    // --------------------------------------------------

    let rawBody: unknown;

    try {
      rawBody = await req.json();
    } catch {
      return jsonResponse({ error: "Cos de la petició invàlid" }, 400);
    }

    const game = validateGame(rawBody);

    if (game === null) {
      return jsonResponse({ error: "Dades del joc invàlides" }, 400);
    }

    // --------------------------------------------------
    // Client administratiu amb la Service Role Key
    // --------------------------------------------------

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { error: upsertError } = await supabaseAdmin
      .from("games")
      .upsert(game, { onConflict: "igdb_id" });

    if (upsertError) {
      console.error("Error desant el joc:", upsertError);

      return jsonResponse({ error: "No s'ha pogut desar el joc" }, 500);
    }

    return jsonResponse({ success: true }, 200);
  } catch (error) {
    console.error("Error inesperat:", error);

    return jsonResponse({ error: "Error intern del servidor" }, 500);
  }
});
