const webpack = require('webpack');


module.exports = {
    lintOnSave: false,
    devServer: {
        proxy: {
            '/api': {
                target: 'http://localhost:8080',
                changeOrigin: true,
            },
        },
    },
    css: {
        extract: true, // 确保 CSS 被正确提取到单独的文件
        sourceMap: false, // 在生产环境中关闭 CSS source map
    },
    chainWebpack: config => {
        config.module
            .rule('js')
            .include
            .add(/node_modules\/vue-echarts/)
            .add(/node_modules\/echarts/)
            .end()
            .use('babel-loader')
            .loader('babel-loader')
            .tap(options => {
                options = options || {};
                options.plugins = (options.plugins || []).concat(['@babel/plugin-transform-optional-chaining']);
                return options;
            });
    },
    configureWebpack: {
        plugins: [
            new webpack.DefinePlugin({
                __VUE_OPTIONS_API__: true, // 如果你使用了 options API，请设置为 true
                __VUE_PROD_DEVTOOLS__: false, // 生产环境中不需要 devtools
                __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: false // 生产环境中不需要 hydration mismatch 细节
            })
        ]
    }
};
