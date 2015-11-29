//= require_tree ./elm-modules

jQuery(function ($) {
  $("[data-elm-module]").each(function(i, element) {
    var moduleName = $(element).data("elmModule");
    var portValues = $(element).data("elmPortValues");
    Elm.embed(Elm[moduleName], element, portValues);
  });
});
