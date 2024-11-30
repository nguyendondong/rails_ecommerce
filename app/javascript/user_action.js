$(document).ready(function() {
  $(".js-form-switch").on("change", function(){
    let confirm_message = "Are you sure you want to change the status?";
  
    if (confirm(confirm_message)) {
      $(this).closest("form").submit();
    } else {
      $(this).prop("checked", !$(this).prop("checked"));
    }
  });
});
