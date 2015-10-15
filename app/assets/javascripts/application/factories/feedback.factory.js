(function () {
    'use strict';
    angular.module('IceApp').factory('FeedbackFactory', ['$http', function($http){
        return {

            send: function(feedback){
                var fd = new FormData();

                fd.append('session_token', feedback.session_token );

                if(feedback.message){
                    fd.append('message', feedback.message );
                }

                return $http.post('/api/v1/feedback', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());