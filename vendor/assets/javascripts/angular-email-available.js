'use strict';

angular.module('validation.email', []);

angular.module('validation.email').directive('emailvalidate', match);

function match ($http) {
    return {
        require: '?ngModel',
        restrict: 'A',
        scope: {
          except: '=except'
        },
        link: function(scope, elem, attrs, ctrl) {

            if(!ctrl) {
                if(console && console.warn){
                    console.warn('Match validation requires ngModel to be on the element');
                }
                return;
            }

            ctrl.$validators.validateEmail = function(viewValue) {
                if (viewValue && viewValue.match(/[a-z0-9\-_]+@[a-z0-9\-_]+\.[a-z0-9\-_]{2,}/)) {
                    ctrl.$setValidity('emailValid', true);
                    $http.post('/users/email_available', {email: viewValue, except: scope.except})
                        .success(function (data, status, headers, config) {
                            ctrl.$setValidity('emailAvailable', true);
                            return viewValue;
                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('emailAvailable', false);
                            return undefined;
                        });
                    return viewValue;
                } else {
                    ctrl.$setValidity('emailValid', false);
                    return undefined;
                }

                return undefined;
            };
        }
    };
}