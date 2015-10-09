(function () {
    'use strict';
    angular.module('IceApp').factory('UsersFactory', ['$http', function($http){
        return {

            upsert: function(user){
                var fd = new FormData();

                fd.append('user[first_name]', user.first_name );
                if(user.last_name){
                    fd.append('user[last_name]', user.last_name );
                }
                if(user.gender){
                    fd.append('user[gender]', user.gender );
                }
                if(user.date_of_birth){
                    fd.append('user[date_of_birth]', user.date_of_birth );
                }
                if(user.user_name){
                    fd.append('user[user_name]', user.user_name );
                }
                if(user.email){
                    fd.append('user[email]', user.email );
                }
                if(user.password){
                    fd.append('user[password]', user.password );
                }
                if(user.password_confirmation){
                    fd.append('user[password_confirmation]', user.password_confirmation );
                }
                if(user.avatar && user.avatar.file){
                    fd.append('user[avatar]', user.avatar.file );
                }

                return $http.post('/api/v1/users', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());