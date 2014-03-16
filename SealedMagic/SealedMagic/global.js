$(document).ready(function () {
    console.log(location.href);
    var hreflist = location.href.toString().replace(".", "/").split('/');
    console.log("x" + hreflist[4]);
    $('#menu_' + hreflist[4]).addClass("chosen_menu");
});