$(document).ready(function() {
  $(document).on("click", ".js-plus", function() {
    var qtyScope = $(this).closest(".quantity-scope");
    var input = qtyScope.find(".count");
    var currentValue = parseInt(input.val());

    input.val(currentValue + 1);
    if (input.hasClass("count-update")) {
      input.trigger("change");
    }
  });

  $(document).on("click", ".js-minus", function() {
    var qtyScope = $(this).closest(".quantity-scope");
    var input = qtyScope.find(".count");
    var currentValue = parseInt(input.val());
    
    if (currentValue > 1) {
      input.val(currentValue - 1);
      if (input.hasClass("count-update")) {
        input.trigger("change");
      }
    }
  });

  $(document).on("change", ".count", function() {
    sendUpdateRequest($(this));
  });

  function sendUpdateRequest(input) {
    var form = input.closest("form");
    form.submit();
  }
});
