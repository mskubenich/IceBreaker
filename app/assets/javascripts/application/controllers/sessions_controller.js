(function () {

    "use strict";

    angular.module('IceApp')
        .controller('SessionsController', ['$scope', '$state', 'ngDialog', '$stateParams', '$timeout', '$sce', 'SessionsFactory',
            function ($scope, $state, ngDialog, $stateParams, $timeout, $sce, sessions) {
                $scope.I18n = I18n;
                $scope._ = _;
                $scope.$state = $state;

                $scope.getHtml = function(html){
                    return $sce.trustAsHtml(html);
                };

                if($state.current.name == 'login'){

                    $scope.session = {};

                    $scope.submitUser = function(){

                        $scope.processing = true;
                        sessions.login($scope.session)
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

                if($state.current.name == 'logout'){

                    $scope.session = {};
                    $scope.headers = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        sessions.logout($scope.headers)
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