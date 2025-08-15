// Deno/Edge function for Supabase
// Endpoint: /functions/v1/create-payment-intent
// Requires: STRIPE_SECRET_KEY in Supabase project environment variables

interface CreateBody { amount: number; currency?: string }

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
    }

    const { amount, currency = "usd" } = await req.json() as CreateBody;

    if (typeof amount !== "number" || !Number.isInteger(amount) || amount <= 0) {
      return new Response(JSON.stringify({ error: "Invalid amount (must be integer cents)" }), { status: 400 });
    }

    const secret = Deno.env.get("STRIPE_SECRET_KEY");
    if (!secret) {
      return new Response(JSON.stringify({ error: "Missing STRIPE_SECRET_KEY env var" }), { status: 500 });
    }

    // Create PaymentIntent via Stripe REST API
    const form = new URLSearchParams();
    form.set("amount", String(amount));
    form.set("currency", currency);
    form.set("automatic_payment_methods[enabled]", "true");

    const resp = await fetch("https://api.stripe.com/v1/payment_intents", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${secret}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: form,
    });

    if (!resp.ok) {
      const errBody = await resp.text();
      return new Response(JSON.stringify({ error: errBody }), { status: resp.status });
    }

    const data = await resp.json();
    return new Response(JSON.stringify(data), { status: 200, headers: { "Content-Type": "application/json" } });

  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
