$(() => {
    $('form').submit((event) => {
        event.preventDefault();

        const model =demo();
        const license_plate = $('#license_plate').val().trim();
        const array = {
            model,
            license_plate
        };

        add(array)
        .then(result => {
            console.log(result);
            window.location = '/dashboard';
        }).catch(error => {
            console.error(error);
            const $errorMessage = $('#errorMessage');
            $errorMessage.text(error.responseJSON.message);
            $errorMessage.show(); 
            //window.alert("Invalid account");
        });
    
    });
});

function add(array) {
return $.post('http://localhost:3000/driver_update/adding_vehicle',array);
}


function demo()
{
  //alert($('#id').val());
  var displaytext = $('#id').val();
  //alert(displaytext);
  return displaytext;

}