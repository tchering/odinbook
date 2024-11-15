import consumer from "channels/consumer";

document.addEventListener("turbo:load", () => {
  const element = document.getElementById("chat-room");

  if (element) {
    const recipient_id = element.getAttribute("data-recipient-id");
    const current_user_id = element.getAttribute("data-current-user-id");

    //     This code ensures that any existing subscriptions to Action Cable channels are removed before creating a new subscription. It prevents multiple simultaneous subscriptions to the same channel, which can cause:

    // Duplicate data reception: If a user is subscribed multiple times, they might receive the same data multiple times.
    // Unnecessary resource usage: Maintaining redundant subscriptions can strain server resources and degrade performance.
    //! Clean up existing subscriptions
    consumer.subscriptions.subscriptions.forEach((subscription) => {
      consumer.subscriptions.remove(subscription);
    });

    consumer.subscriptions.create(
      {
        channel: "MessageChannel",
        recipient_id: recipient_id,
        current_user_id: current_user_id,
      },
      {
        connected() {
          console.log("Connected to the message channel");
        },

        disconnected() {
          console.log("Left message channel");
        },

        received(data) {
          const messageDisplay = document.querySelector("#message-display");
          const currentUserId = element.getAttribute("data-current-user-id");

          // Only clear input if current user is the sender
          if (data.sender.id.toString() === currentUserId) {
            document.querySelector("#message-input").value = "";
          }

          messageDisplay.insertAdjacentHTML(
            "beforeend",
            this.template(data, currentUserId)
          );
          messageDisplay.scrollTop = messageDisplay.scrollHeight;
        },

        template(data, currentUserId) {
          const messageClass =
            data.sender.id.toString() === currentUserId ? "sent" : "received";
          const timestamp = new Date(data.created_at).toLocaleString("en-US", {
            hour: "numeric",
            minute: "numeric",
            hour12: true,
          });

          return `
            <div class="message ${messageClass}">
              <div class="message-content">
                <p>${data.body}</p>
                <span class="timestamp">${timestamp}</span>
              </div>
            </div>
          `;
        },
      }
    );
  }
});
