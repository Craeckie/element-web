/*
Copyright 2015, 2016 OpenMarket Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

'use strict';

var React = require('react');

module.exports = React.createClass({
    displayName: 'VectorLoginFooter',
    statics: {
        replaces: 'LoginFooter',
    },

    render: function() {
        return (
            <div className="mx_Login_links">
                <a href="https://twitter.com/@VectorCo">twitter</a>&nbsp;&nbsp;&middot;&nbsp;&nbsp;
                <a href="https://medium.com/@Vector">blog</a>&nbsp;&nbsp;&middot;&nbsp;&nbsp;-->
                <a href="https://github.com/vector-im/vector-web">github</a>&nbsp;&nbsp;&middot;&nbsp;&nbsp;
                <a href="https://matrix.org">powered by Matrix</a>
            </div>
        );
    }
});
