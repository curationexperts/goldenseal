Blacklight.onLoad(function() {
  // This takes care of loading the angular app with Turbolinks
  var app = angular.module('myApp', [])
    .controller('TeiViewer', ['$scope', '$sce', TeiViewer])
    .directive('teiViewer', TeiViewerDirective);
  angular.bootstrap('body', ['myApp']);
})

function TeiViewer($scope, $sce) {

  $scope.currentPage = 1;
  $scope.formNumber = 1;
  $scope.maxPage = "1";
  $scope.pages = [];
  $scope.imagesOnly = false;
  $scope.display = "both";

  $scope.build = function (book) {
    $scope.pages = book.pages;
    $scope.maxPage = $scope.pages.length;
  }

  $scope.to_trusted = function(html_code) {
    return $sce.trustAsHtml(html_code);
  }

  $scope.previousPage = function (){
    if($scope.currentPage > 1) {
      $scope.currentPage--;
      $scope.formNumber = $scope.currentPage;
    }
  }

  $scope.nextPage = function (){
    if($scope.currentPage < $scope.maxPage) {
      $scope.currentPage++;
      $scope.formNumber = $scope.currentPage;
    }
  }

  $scope.textUpdated = function () {
    if ($scope.formNumber < 1) {
      // Less than one
      $scope.formNumber = $scope.currentPage;
    } else {
      var newVal = parseInt($scope.formNumber);
      if (newVal <= $scope.maxPage) {
        // Looks good, update currentPage
        $scope.currentPage = newVal;
      } else {
        // Larger than the allowed value
        $scope.formNumber = $scope.currentPage;
      }
    }
  }
}


function TeiViewerDirective() {
    function linkingFunction(scope, element, attrs) {
        //expecting there is some json in this variable.
        if(tei.error) {
          alert("The supplied transcript is not formatted properly for playback")
        } else {
          scope.build(tei);
          scope.$watch("currentPage", scrollToPage);
          scope.$watch("display", function() {
            scrollToPage(scope.currentPage);
          });
        }
    }
    function scrollToPage(pageNumber) {
        var firstOffset = document.querySelectorAll('#tei-container li.page:nth-child(1)')[0].offsetTop;
        var elements = document.querySelectorAll('#tei-container li.page:nth-child(' + pageNumber + ')');
        var container = document.getElementById('tei-container');
        container.scrollTop = elements[0].offsetTop - firstOffset;
    };
    return {
        restrict: 'E',
        templateUrl: 'tei_viewer.html',
        link: linkingFunction
    };
}
