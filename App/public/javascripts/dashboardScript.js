$(() => {

    
    $('#form2').submit((event) => {
        event.preventDefault();
        const driver_status = $('#driver').val();

        if(driver_status == 'Registered'){
            window.location = '/driver_update';
        }
        else{
            window.location = '/driver_update/add_driver';
        }
    });

});