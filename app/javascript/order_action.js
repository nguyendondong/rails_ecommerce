$(document).ready(function() {
  var submitbtn = $(".js-update-order-btn");
  var cancelReasonField = $("#js-cancel-reason");

  $(".js-order-status").on("change", function() {
    var isCanceled = $(this).val() === "canceled";

    cancelReasonField.toggle(isCanceled);
    submitbtn.attr("disabled", isCanceled).val(isCanceled ? "Refuse Order" : "Update Order Status");
    submitbtn.toggleClass("btn-danger", isCanceled);
  });

  $(".js-cancel-reason-input").on("input", function() {
    submitbtn.prop("disabled", $(this).val().trim() == "");
  });
});
