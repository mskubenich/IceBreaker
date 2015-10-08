(function () {
    "use strict";
    var IceApp = angular.module('IceApp', [
        'ui.router',
        'templates',
        'ngDialog',
        'validation.match',
        'validation.email',
        'fileread',
        'ui.bootstrap',
        'bootstrapLightbox',
        'ui-rangeSlider',
        'redactor',
        'formInput.images',
        'formInput.image'
    ]);

    IceApp.config(['$urlRouterProvider', '$stateProvider', '$httpProvider',
        function ($urlRouterProvider, $stateProvider, $httpProvider) {

            $httpProvider.defaults.headers.common['X-Requested-With'] = 'AngularXMLHttpRequest';

            $urlRouterProvider.otherwise('home');

            $stateProvider
              .state('home',{
                  url: '',
                  templateUrl: 'application/templates/home/index.html',
                  controller: 'HomeController'
              });
            // generated routes:
    }]);

    IceApp.run(['$http', '$rootScope', function($http, $rootScope){
        var csrf_token = $('meta[name="csrf-token"]').attr('content');
        $http.defaults.headers.common['X-CSRF-Token'] = csrf_token;
    }]);

    IceApp.service('AuthHttp',['$http', '$q', 'ngDialog', function($http, $q, ngDialog){
        var urlWithLoginCredentials = function(url, email, password) {
            return url + (url.indexOf('?') >= 0 ? '&' : '?') + 'session[email]=' + email + '&session[password]=' + password;
        };

        var dialog = null;
        var qw = function(){
            return {
                success: function (callback) {
                    this.callbacks.success = callback;
                    return this;
                },
                error: function (callback) {
                    this.callbacks.error = callback;
                    return this;
                },
                request: function (method, url, data) {
                    var self = this;
                    var req = {
                        async: true,
                        cache: false,
                        method: method,
                        url: url,
                        data: data
                    };

                    $http(req)
                            .success(function (data, status, headers, config) {
                                if(dialog){
                                    dialog.close();
                                }
                                self.callbacks.success(data, status, headers, config);
                            })
                            .error(function (data, status, headers, config) {
                                if (status == 401) {
                                    if (!dialog) {
                                        dialog = ngDialog.open({
                                            className: 'ngdialog-theme-default',
                                            template: 'application/templates/home/login.html',
                                            controller: ['$scope', function ($scope) {
                                                $scope.submitLoginCredentials = function(){
                                                    self.request(method, urlWithLoginCredentials(url, $scope.email, $scope.password), data);
                                                };
                                            }],
                                            showClose: false,
                                            closeByDocument: false,
                                            closeByEscape: false
                                        });
                                    }
                                } else {
                                    if(dialog){
                                        dialog.close();
                                    }
                                    self.callbacks.error(data, status, headers, config);
                                }
                            });
                },
                callbacks: {
                    success: function () {
                    },
                    error: function () {
                    }
                }
            }
        };

        return {
            get: function (url) {
                var ins = new qw;
                ins.request('GET', url);
                return ins;
            },
            post: function (url, data) {
                var ins = new qw;
                ins.request('POST', url, data);
                return ins;
            },
            put: function (url, data) {
                var ins = new qw;
                ins.request('PUT', url, data);
                return ins;
            },
            delete: function (url, data) {
                var ins = new qw;
                ins.request('DELETE', url, data);
                return ins;
            }
        }
    }])


}());