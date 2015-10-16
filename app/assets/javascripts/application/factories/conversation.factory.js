(function () {
    'use strict';
    angular.module('IceApp').factory('ConversationsFactory', ['$http', function($http){
        return {

            get_page: function(conversation){
                var session_token = conversation.session_token ? conversation.session_token : '';
                var per_page = conversation.per_page ? conversation.per_page : '';
                var page = conversation.page ? conversation.page : '';

                return $http.get('/api/v1/conversations?session_token=' + session_token + '&per_page=' + per_page + '&page=' + page)
            },
            show: function(conversation){
                return $http.get('/api/v1/conversations/' + conversation.id + '?session_token=' + conversation.session_token)
            },
            remove: function(conversation){
                return $http.delete('/api/v1/conversations/' + conversation.id + '?session_token=' + conversation.session_token)
            }
        }
    }])
}());