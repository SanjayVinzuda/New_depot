 $('#notice').hide();
 if ($('#cart tr').length == 1) { $('#cart').show('blind', 1000); }

$('#cart').html("<%= escape_javascript render(@cart) %>");

$('#current_item').css({'background-color':'#55cc11'}).animate({'background-color':'#114411'}, 1000);



