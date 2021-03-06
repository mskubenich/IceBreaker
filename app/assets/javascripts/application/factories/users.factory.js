(function () {
    'use strict';
    angular.module('IceApp').factory('UsersFactory', ['$http', function($http){
        return {

            create: function(user){
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
                if(user.device){
                    fd.append('device', user.device );
                }
                if(user.device_token){
                    fd.append('device_token', user.device_token );
                }

                return $http.post('/api/v1/users', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            },

            update: function(user){
                var fd = new FormData();

                fd.append('first_name', user.first_name );
                if(user.session_token){
                    fd.append('session_token', user.session_token );
                }
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

                return $http.put('/api/v1/users/update_profile', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            },

            mute: function(user){
                var fd = new FormData();

                fd.append('session_token', user.session_token ? user.session_token : '' );
                fd.append('opponent_id', user.opponent_id ? user.opponent_id : '' );

                return $http.post('/api/v1/users/mute', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());