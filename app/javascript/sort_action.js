$(document).ready(function() {
  $(".js-priceSort").on("click", function() {
    let price_desc = $("input[name='q[s][]'][value='price desc']");
    let price_asc = $("input[name='q[s][]'][value='price asc']");
    price_desc.prop("checked", !price_desc.prop("checked"));
    price_asc.prop("checked", !price_desc.prop("checked"));
    $(".form_sort_product").submit();
  });

  $(".js-nameSort").on("click", function() {
    let created_at_desc = $("input[name='q[s][]'][value='name desc']");
    let created_at_asc = $("input[name='q[s][]'][value='name asc']");
    created_at_desc.prop("checked", !created_at_desc.prop("checked"));
    created_at_asc.prop("checked", !created_at_desc.prop("checked"));
    $(".form_sort_product").submit();
  });
});
