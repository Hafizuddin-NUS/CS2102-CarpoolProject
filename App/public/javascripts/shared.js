$(() => {

    $('form1').submit((event) => {
        event.preventDefault();
        const driver_status = $('#driver').val();
        alert(driver_status);
        if(driver_status == "Registered"){
            window.location ='/driver_update';
        }
        else {
            window.location = '/dashboard';
        }
             
    });
});

function goto() {
return $.get('http://localhost:3000/driver_update');
}