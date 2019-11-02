$(() => {


    $('#form2').submit((event) => {
        event.preventDefault();
        const driver_status = $('#driver').val();

        if (driver_status == 'Registered') {
            window.location = '/driver_update';
        }
        else {
            window.location = '/driver_update/add_driver';
        }
    });

    //Assign Click event to Button.
    $("#btnDeleteUser").click(function () {
        const username = $('#username').val();
        const user = {
            username
        }
        delete_users(user)
            .then(result => {
                console.log(result);
                window.location = '../';
                window.alert("User have been deleted successfully");
            }).catch(error => {
                console.error(error);
                const $errorMessage = $('#errorMessage');
                $errorMessage.text(error.responseJSON.message);
                $errorMessage.show();
                //window.alert("Invalid account");
            });
    });
});

function delete_users(user) {
    return $.post('http://localhost:3000/dashboard/delete_users', user);
}