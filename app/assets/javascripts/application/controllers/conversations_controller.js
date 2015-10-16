(function () {

    "use strict";

    angular.module('IceApp')
        .controller('ConversationsController', ['$scope', '$state', 'ngDialog', '$stateParams', '$timeout', '$sce', 'ConversationsFactory',
            function ($scope, $state, ngDialog, $stateParams, $timeout, $sce, conversations) {
                $scope.I18n = I18n;
                $scope._ = _;
                $scope.$state = $state;

                $scope.getHtml = function(html){
                    return $sce.trustAsHtml(html);
                };

                if($state.current.name == 'conversations'){

                    $scope.conversation = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        conversations.get_page($scope.conversation)
                            .success(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                            .error(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                    };
                }
                if($state.current.name == 'conversation'){

                    $scope.conversation = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        conversations.show($scope.conversation)
                            .success(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                            .error(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                    };
                }
                if($state.current.name == 'remove_conversation'){

                    $scope.conversation = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        conversations.remove($scope.conversation)
                            .success(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                            .error(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                    };
                }
            }])
}());