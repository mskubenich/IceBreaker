(function () {

    "use strict";

    angular.module('IceApp')
        .controller('UsersController', ['$scope', '$state', 'ngDialog', '$stateParams', '$timeout', '$sce', 'UsersFactory',
            function ($scope, $state, ngDialog, $stateParams, $timeout, $sce, users) {
                $scope.I18n = I18n;
                $scope._ = _;
                $scope.$state = $state;

                $scope.getHtml = function(html){
                    return $sce.trustAsHtml(html);
                };


                if($state.current.name == 'new_user'){

                    $scope.user = {};

                    $scope.submitUser = function(){

                        $scope.processing = true;
                        users.create($scope.user)
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

                if($state.current.name == 'edit_profile'){

                    $scope.user = {};

                    $scope.submitUser = function(){

                        $scope.processing = true;
                        users.update($scope.user)
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