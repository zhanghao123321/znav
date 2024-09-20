// routes/routes.go

package routes

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"znav/backend/controllers"
	"znav/backend/middlewares"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()

	// 配置 CORS 中间件
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE"}
	config.AllowHeaders = []string{"Origin", "Authorization", "Content-Type"}

	router.Use(cors.New(config))

	public := router.Group("/api")
	public.POST("/login", controllers.Login)
	public.GET("/applications", controllers.GetApplications) // 公开访问
	public.GET("/menus", controllers.GetMenus)               // 公开访问
	public.GET("/settings", controllers.GetSiteSettings)

	// 注册每日一言的路由
	public.GET("/hitokoto", controllers.HitokotoHandler)
	// 注册热榜路由
	public.GET("/hotrank", controllers.HotRankHandler)

	// 采集网站
	public.GET("/scrape-website", controllers.ScrapeWebsiteHandler)

	private := router.Group("/api")
	private.Use(middlewares.AuthMiddleware())

	// 应用管理
	private.POST("/applications", controllers.CreateApplication)
	private.PUT("/applications/:id", controllers.UpdateApplication)
	private.DELETE("/applications/:id", controllers.DeleteApplication)

	// 菜单管理
	private.POST("/menus", controllers.CreateMenu)
	private.PUT("/menus/:id", controllers.UpdateMenu)
	private.DELETE("/menus/:id", controllers.DeleteMenu)

	// 批量删除
	private.POST("/menus/batch_delete", controllers.BatchDeleteMenus)
	private.POST("/applications/batch_delete", controllers.BatchDeleteApplications)

	// 退出登录
	private.POST("/logout", controllers.Logout)

	// 站点设置
	private.PUT("/settings", controllers.UpdateSiteSettings)

	// 获取数据统计
	private.GET("/applications/total", controllers.GetTotalApplications)   // 获取总应用数量
	private.GET("/applications/recent", controllers.GetRecentApplications) // 获取最近新增应用
	private.GET("/menus/total", controllers.GetTotalMenus)                 // 获取总菜单数量
	private.GET("/users/total", controllers.GetTotalUsers)                 // 获取总用户数量

	// 用户管理
	private.GET("/users", controllers.GetUsers)                    // 获取用户列表
	private.GET("/user", controllers.GetCurrentUser)               // 获取当前登录用户信息
	private.POST("/users", controllers.CreateUser)                 // 创建用户
	private.PUT("/users/password", controllers.UpdateUserPassword) // 更新用户密码
	private.PUT("/users/status", controllers.UpdateUserStatus)     // 更新用户状态
	private.PUT("/users/admin", controllers.UpdateUserAdminStatus) // 更新用户管理员权限
	private.PUT("/users", controllers.UpdateUser)
	private.DELETE("/users/:id", controllers.DeleteUser) // 删除用户

	return router
}
