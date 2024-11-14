import consumer from "channels/consumer";

// document.addEventListener("turbo:load", () => {
//   consumer.subscriptions.create(
//     { channel: "NotificationChannel" },
//     {
//       connected() {
//         console.log("connection to notification channel");
//       },

//       received(data) {
//         const badge = document.querySelector(
//           `#notification_count_${data.sender_id}`
//         );
//         if (badge) {
//           if (data.count === 0) {
//             badge.classList.add("d-none");
//           } else {
//             badge.classList.remove("d-none");
//             badge.textContent = data.count;
//           }
//         }
//       },
//     }
//   );
// });
//this above will work but throw some console error thats why we did below

const createNotificationSubscription = () => {
  consumer.subscriptions.create(
    { channel: "NotificationChannel" },
    {
      connected() {
        console.log("Connected to notification channel");
      },

      disconnected() {
        console.log("Disconnected from notification channel");
      },

      received(data) {
        try {
          console.log("Received notification data:", data);
          const badge = document.querySelector(
            `#notification_count_${data.sender_id}`
          );

          if (!badge) {
            console.warn(
              `Badge element not found for sender ${data.sender_id}`
            );
            return;
          }

          badge.classList.toggle("d-none", data.count === 0);
          badge.textContent = data.count;
        } catch (error) {
          console.error("Error handling notification:", error);
        }
      },

      rejected() {
        console.log("Subscription was rejected");
      },
    }
  );
};

// Handle both initial page load and subsequent Turbo navigations
document.addEventListener("turbo:load", createNotificationSubscription);

// Cleanup old subscriptions before new ones
document.addEventListener("turbo:before-render", () => {
  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription);
  });
});
