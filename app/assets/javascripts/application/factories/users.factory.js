(function () {
    'use strict';
    angular.module('IceApp').factory('UsersFactory', ['$http', function($http){
        return {

            upsert: function(user){
                var fd = new FormData();

                fd.append('first_name', user.first_name );
                if(user.last_name){
                    fd.append('last_name', user.last_name );
                }
                if(user.gender){
                    fd.append('gender', user.gender );
                }
                if(user.date_of_birth){
                    fd.append('date_of_birth', user.date_of_birth );
                }
                if(user.user_name){
                    fd.append('user_name', user.user_name );
                }
                if(user.email){
                    fd.append('email', user.email );
                }
                if(user.password){
                    fd.append('password', user.password );
                }
                if(user.password_confirmation){
                    fd.append('password_confirmation', user.password_confirmation );
                }
                if(user.avatar && user.avatar.file){
                    fd.append('avatar', user.avatar.file );
                }
                if(user.show_email){
                    fd.append('show_email', user.show_email );
                }

                return $http.post('/api/v1/users', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());