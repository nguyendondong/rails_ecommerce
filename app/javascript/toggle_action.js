$(document).ready(function() {
  $(".js-show-details-btn").on("click", function() {
    var $button = $(this);

    if ($button.attr("aria-expanded") === "false") {
      $button.text("Show Details");
    } else {
      $button.text("Hide Details");
    }
  });

  $(".js-order-cancellation-form .js-order_cancellation_reason").on("input", function() {
    var cancellationReason = $(this).val().trim();
    var cancelButton = $(this).closest(".js-order-cancellation-form").find(".js-submit-cancel-btn");

    cancelButton.prop("disabled", cancellationReason.length <= 0);
  });
});
