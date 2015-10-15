(function () {
    'use strict';
    angular.module('IceApp').factory('SessionsFactory', ['$http', function($http){
        return {

            login: function(session){
                var fd = new FormData();

                fd.append('login', session.login );
                fd.append('password', session.password );
                fd.append('device', session.device );
                fd.append('device_token', session.device_token );

                return $http.post('/api/v1/sessions', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            },

            logout: function(headers){
                return $http.delete('/api/v1/sessions?session_token=' + headers.session_token );
            },

            logout_all: function(headers){
                return $http.delete('/api/v1/sessions/destroy_all?session_token=' + headers.session_token );
            },

            login_with_facebook: function(user){
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
                if(user.facebook_uid){
                    fd.append('facebook_uid', user.facebook_uid );
                }
                if(user.facebook_avatar){
                    fd.append('facebook_avatar', user.facebook_avatar );
                }
                if(user.device){
                    fd.append('device', user.device );
                }
                if(user.device_token){
                    fd.append('device_token', user.device_token );
                }

                return $http.post('/api/v1/sessions/facebook', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());