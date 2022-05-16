const { eventarc } = require("firebase-functions/v2");
const functions = require("firebase-functions");

const { IncomingWebhook } = require("@slack/webhook");

const webhook = new IncomingWebhook("{YOUR_SLACK_URL}");

exports.stripeproductcreatedv1 = eventarc.onCustomEventPublished(
  "com.stripe.v1.product.created",
  async (product) => {
    await webhook.send({
      text: `New product added, ${product.data.name} (${product.data.id})`,
    });
  }
);
