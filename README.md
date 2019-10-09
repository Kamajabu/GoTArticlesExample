<h1 class="code-line" data-line-start=0 data-line-end=1 ><a id="OmniNews_0"></a>GoTArticlesExample</h1>
<p class="has-line-data" data-line-start="1" data-line-end="2">The main goal of the app is to fetch a list of Wikia’s and display the most viewed articles about characters of Game Of Thrones Wiki using API at: http://gameofthrones.wikia.com/api
</p>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Plugin</th>
<th>README</th>
</tr>
</thead>
<tbody>
<tr>
<td>Architecture</td>
<td>MVVM+C, RxSwift for bindings and data management</td>
</tr>
<tr>
<td>Views</td>
<td>Code only, Autolayout, no storyboards, no XIBs</td>
</tr>
<tr>
<td>Dependency manager</td>
<td>CocoaPods</td>
</tr>
<tr>
<td>Test frameworks</td>
<td>Quick, Nimble, RxTest</td>
</tr>
<tr>
<td>Other dependencies</td>
<td>RxSwift, RxCocoa, RxGesture, EasyPeasy</td>
</tr>
</tbody>
</table>
<ul>
<li class="has-line-data" data-line-start="10" data-line-end="11">Interesting requirement - details in cell placed in ArticlesList are shortened to 2 lines of description, however, the user should be able to extend the visible description by a long-press gesture. The visible area should enable the user to see whole description. Performing the long press gesture again should collapse that entry to previous height. Some nice auto-layout magic is presented there.
</li>
