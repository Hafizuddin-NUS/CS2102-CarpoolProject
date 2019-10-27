$(() => {
    $('form').submit((event) => {
        event.preventDefault();

        const type =demo();
        const array = {
            type
        };

        window.location='/driver_update/add_vehicle=' +type;
    
    });
});

function add(type) {
return $.get('http://localhost:3000/driver_update/add_vehicle',type);
}


function demo()
{
  //alert($('#id').val());
  var displaytext = $('#id').val();
  //alert(displaytext);
  return displaytext;

}