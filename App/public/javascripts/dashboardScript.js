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
                if(result.message == 'Unable to delete user') {
                    console.log(result);
                    window.alert(result.trggier_msg.payload);
                } else if (result.message == 'Successfully deleted user') {
                    console.log(result);
                    logout().then(result2 => {
                        console.log(result2);
                        window.location = '../'
                        window.alert("User have been deleted successfully");
                    }).catch(error => {
                        console.error(error);
                    });
                } 
            }).catch(error => {
                console.error(error);
            });
    });

    //Assign Click event to Button.
    $("#btnGet").click(function () {
        $("#dataTable input[type=checkbox]:checked").each(function () {
            const row = $(this).closest("tr")[0];
            const license_plate = row.cells[1].innerHTML;
            const seats_offered = row.cells[2].innerHTML;
            
            const selected_row = {
                license_plate,
                seats_offered
             };
             console.log(selected_row);

             delete_car(selected_row)
            .then(result => {
                console.log(selected_row);
                window.location = '/dashboard';
            }).catch(error => { 
                console.error(error);
                //window.alert("Invalid account");
            });
        });

    });
});

function delete_users(user) {
    return $.post('http://localhost:3000/dashboard/delete_users', user);
}

function logout() {
    return $.get('http://localhost:3000/auth/logout');
}

function delete_car(selected_row) {
    return $.post('http://localhost:3000/dashboard/delete_car',selected_row);
}