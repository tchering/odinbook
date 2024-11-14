import consumer from "channels/consumer";

document.addEventListener("turbo:load", () => {
  const element = document.getElementById("chat-room");

  if (element) {
    const recipient_id = element.getAttribute("data-recipient-id");

    consumer.subscriptions.create(
      {
        channel: "MessageChannel",
        recipient_id: recipient_id,
      },
      {
        connected() {
          console.log("Connected to the message channel");
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log("Left message channel");
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          const messageDisplay = document.querySelector("#message-display");
          const currentUserId = element.getAttribute("data-current-user-id");
          messageDisplay.insertAdjacentHTML(
            "beforeend",
            this.template(data, currentUserId)
          );
          document.querySelector("#message-input").value = "";
          messageDisplay.scrollTop = messageDisplay.scrollHeight;
        },

        template(data, currentUserId) {
          const messageClass =
            data.sender.id == currentUserId ? "sent" : "received";
          const timestamp = new Date().toLocaleString("en-US", {
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
