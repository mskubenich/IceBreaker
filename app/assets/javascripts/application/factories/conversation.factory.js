(function () {
    'use strict';
    angular.module('IceApp').factory('ConversationsFactory', ['$http', function($http){
        return {

            get_page: function(conversation){
                var fd = new FormData();

                var session_token = conversation.session_token ? conversation.session_token : '';
                var per_page = conversation.per_page ? conversation.per_page : '';
                var page = conversation.page ? conversation.page : '';

                return $http.get('/api/v1/conversations?session_token=' + session_token + '&per_page=' + per_page + '&page=' + page)
            }
        }
    }])
}());