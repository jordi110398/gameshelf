import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {

  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }
  try {
    const { query } = await req.json();

    if (!query || query.trim() === "") {
      return new Response(
        JSON.stringify({ error: "Missing query" }),
        {
          status: 400,
          headers: {
            "Content-Type": "application/json",
          },
        },
      );
    }

    const clientId = Deno.env.get("TWITCH_CLIENT_ID");
    const clientSecret = Deno.env.get("TWITCH_CLIENT_SECRET");

    console.log("TWITCH_CLIENT_ID =", clientId);
    console.log("TWITCH_CLIENT_SECRET exists =", clientSecret !== undefined);

    if (!clientId || !clientSecret) {
      return new Response(
        JSON.stringify({ error: "Missing Twitch credentials" }),
        {
          status: 500,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // OAuth Token
    const tokenResponse = await fetch(
      "https://id.twitch.tv/oauth2/token",
      {
        method: "POST",
        headers: {
          ...corsHeaders,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          client_id: clientId,
          client_secret: clientSecret,
          grant_type: "client_credentials",
        }),
      },
    );

    if (!tokenResponse.ok) {
      return new Response(
        await tokenResponse.text(),
        {
          status: tokenResponse.status,
        },
      );
    }

    const token = await tokenResponse.json();

    // IGDB
    const igdbResponse = await fetch(
      "https://api.igdb.com/v4/games",
      {
        method: "POST",
        headers: {
          ...corsHeaders,
          "Client-ID": clientId,
          "Authorization": `Bearer ${token.access_token}`,
          "Content-Type": "text/plain",
        },
        body: `
search "${query}";
fields
  id,
  name,
  slug,
  summary,
  storyline,
  first_release_date,
  rating,
  rating_count,
  cover.url,
  genres.name,
  platforms.name;
limit 20;
`,
      },
    );

    if (!igdbResponse.ok) {
      return new Response(
        await igdbResponse.text(),
        {
          status: igdbResponse.status,
        },
      );
    }

    const games = await igdbResponse.json();

    const result = games.map((game: any) => ({
      igdb_id: game.id,
      title: game.name,
      slug: game.slug,
      summary: game.summary,
      storyline: game.storyline,
      release_date: game.first_release_date
        ? new Date(game.first_release_date * 1000).toISOString()
        : null,
      rating: game.rating,
      rating_count: game.rating_count,
      cover_url: game.cover?.url
        ? `https:${game.cover.url.replace("t_thumb", "t_cover_big")}`
        : null,
      genres: Array.isArray(game.genres)
        ? game.genres.map((g: { name: string }) => g.name)
        : [],
      platforms: Array.isArray(game.platforms)
        ? game.platforms.map((p: { name: string }) => p.name)
        : [],
    }));

    return new Response(
      JSON.stringify(result),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({
        error: e.message,
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