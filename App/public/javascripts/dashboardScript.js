$(() => {

    
    $('form').submit((event) => {
        event.preventDefault();
        const driver_status = $('#driver').val();

        if(driver_status == 'Registered'){
            window.location = '/driver_update';
        }
        else{
            window.location = '/dashboard';
        }
    });

});

function add_driver() {
    return $.post('http://localhost:3000/driver_update');
}