$( document ).ready(function() {
   
    $('.colors').hide();


    $('.list > li a').click(function () {
    $(this).parent().find('ul').toggle(500);
    
    
});



$('.listTwo > li a').hover(function () {
    $(this).parent().find('ul').toggle(500);
});


});


