<template>
  <div class="admin-management">
    <!-- 添加用户按钮，仅管理员可见 -->
    <div class="header">
      <el-button
          v-if="isAdmin"
          type="primary"
          class="add-user-btn"
          @click="openUserForm('add')"
      >
        添加用户
      </el-button>
    </div>

    <!-- 用户列表 -->
    <div v-if="users.length > 0" class="user-table-container">
      <el-table :data="users" border stripe style="width: 100%;">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="150" align="center" />
        <!-- 管理员列 -->
        <el-table-column prop="is_admin" label="管理员" width="100" align="center">
          <template #default="{ row }">
            <el-tag
                effect="plain"
                @click="toggleUserAdmin(row)"
                class="clickable-admin"
                :style="getTagStyle(row.is_admin)"
            >
              {{ row.is_admin ? '启' : '停' }}
            </el-tag>
          </template>
        </el-table-column>

        <!-- 状态列 -->
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag
                effect="plain"
                @click="toggleUserStatus(row)"
                class="clickable-status"
                :style="getTagStyle(row.status === 'enabled')"
            >
              {{ row.status === 'enabled' ? '启' : '停' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="200" align="center">
          <template #default="{ row }">
            <span>{{ new Date(row.created_at).toLocaleString() }}</span>
          </template>
        </el-table-column>
        <!-- 操作列 -->
        <el-table-column
            label="操作"
            width="200"
            fixed="right"
            align="center"
        >
          <template #default="{ row }">
            <div v-if="isAdmin || row.username === loggedInUser" class="action-buttons">
              <!-- 编辑按钮 -->
              <el-tooltip content="编辑" placement="top">
                <el-button
                    link
                    class="edit-btn"
                    @click="openUserForm('edit', row)"
                >
                  <i class="el-icon-edit" /> 编辑
                </el-button>
              </el-tooltip>
              <!-- 删除按钮，仅管理员可见，且不能删除自己 -->
              <el-tooltip content="删除" placement="top" v-if="isAdmin && row.username !== loggedInUser">
                <el-button
                    link
                    class="delete-btn"
                    @click="handleDelete(row)"
                >
                  <i class="el-icon-delete" /> 删除
                </el-button>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 添加/修改用户表单弹窗 -->
    <el-dialog
        :title="dialogTitle"
        v-model="showForm"
        width="50%"
    >
      <!-- 编辑模式 -->
      <template v-if="isEditing">
        <el-form :model="formModel" :rules="rules" ref="form" label-width="100px">
          <!-- 管理员编辑用户信息 -->
          <template v-if="isAdmin">
            <!-- 用户名（只读） -->
            <el-form-item label="用户名">
              <el-input v-model="currentUser.username" disabled />
            </el-form-item>
            <!-- 密码 -->
            <el-form-item label="密码" prop="password">
              <el-input
                  type="password"
                  v-model="currentUser.password"
                  placeholder="如需修改密码，请输入新密码"
              />
            </el-form-item>
            <!-- 管理员选项 -->
            <el-form-item label="管理员">
              <el-switch
                  v-model="currentUser.is_admin"
                  :active-value="true"
                  :inactive-value="false"
                  active-text="启"
                  inactive-text="停"
              />
            </el-form-item>
            <!-- 状态选项 -->
            <el-form-item label="状态">
              <el-switch
                  v-model="currentUser.status"
                  :active-value="'enabled'"
                  :inactive-value="'disabled'"
                  active-text="启"
                  inactive-text="停"
              />
            </el-form-item>
          </template>

          <!-- 普通用户修改自己的密码 -->
          <template v-else>
            <!-- 原密码 -->
            <el-form-item label="原密码" prop="currentPassword">
              <el-input
                  type="password"
                  v-model="passwordForm.currentPassword"
                  placeholder="请输入原密码"
              />
            </el-form-item>
            <!-- 新密码 -->
            <el-form-item label="新密码" prop="newPassword">
              <el-input
                  type="password"
                  v-model="passwordForm.newPassword"
                  placeholder="请输入新密码"
              />
            </el-form-item>
            <!-- 确认新密码 -->
            <el-form-item label="确认新密码" prop="confirmPassword">
              <el-input
                  type="password"
                  v-model="passwordForm.confirmPassword"
                  placeholder="请再次输入新密码"
              />
            </el-form-item>
          </template>
        </el-form>
      </template>

      <!-- 添加模式 -->
      <template v-else>
        <el-form :model="currentUser" :rules="rules" ref="form" label-width="100px">
          <!-- 用户名 -->
          <el-form-item label="用户名" prop="username">
            <el-input v-model="currentUser.username" placeholder="请输入用户名" />
          </el-form-item>
          <!-- 密码 -->
          <el-form-item label="密码" prop="password">
            <el-input
                type="password"
                v-model="currentUser.password"
                placeholder="请输入密码"
            />
          </el-form-item>
          <!-- 管理员选项，仅管理员可见 -->
          <el-form-item label="管理员" v-if="isAdmin">
            <el-switch
                v-model="currentUser.is_admin"
                :active-value="true"
                :inactive-value="false"
                active-text="启"
                inactive-text="停"
            />
          </el-form-item>
          <!-- 状态选项，仅管理员可见 -->
          <el-form-item label="状态" v-if="isAdmin">
            <el-switch
                v-model="currentUser.status"
                :active-value="'enabled'"
                :inactive-value="'disabled'"
                active-text="启"
                inactive-text="停"
            />
          </el-form-item>
        </el-form>
      </template>

      <!-- 弹窗的底部按钮 -->
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showForm = false">取消</el-button>
          <el-button type="primary" @click="submitUser">确认</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>


<script>
import axios from 'axios';

export default {
  data() {
    return {
      users: [],
      currentUser: {
        id: null,
        username: '',
        password: '',
        status: 'enabled',
        is_admin: false
      },
      passwordForm: {
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      isEditing: false,
      showForm: false,
      originalUserData: null,
      loggedInUser: this.$store.state.username,
      isAdmin: false,
      rules: {
        // 添加模式下和管理员编辑时的验证规则
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { pattern: /^[a-zA-Z0-9]+$/, message: '用户名只能包含英文+数字', trigger: 'blur' }
        ],
        password: [
          { min: 5, message: '密码至少为5个字符', trigger: 'blur' }
        ],
        // 普通用户修改密码的验证规则
        currentPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 5, message: '新密码至少为5个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' }
        ]
      }
    };
  },
  computed: {
    dialogTitle() {
      if (this.isEditing) {
        return this.isAdmin ? '编辑用户' : '修改密码';
      } else {
        return '添加用户';
      }
    },
    formModel() {
      if (this.isEditing) {
        return this.isAdmin ? this.currentUser : this.passwordForm;
      } else {
        return this.currentUser;
      }
    }
  },
  created() {
    this.getLoggedInUser();
  },
  methods: {
    getLoggedInUser() {
      axios.get(`${process.env.VUE_APP_API_URL}/user`, {
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      }).then(response => {
        this.loggedInUser = response.data.user.username;
        this.isAdmin = response.data.user.is_admin; // 获取当前用户是否为管理员
        this.fetchUsers(); // 获取用户列表
      }).catch(error => {
        console.error('Failed to fetch logged in user:', error);
      });
    },
    fetchUsers() {
      axios.get(`${process.env.VUE_APP_API_URL}/users`, {
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      }).then(response => {
        this.users = response.data.users;
      }).catch(error => {
        console.error('Failed to fetch users:', error);
      });
    },
    // 在 openUserForm() 方法中，当编辑用户时，保存原始数据
    openUserForm(action, user = null) {
      this.isEditing = action === 'edit';
      if (this.isEditing) {
        this.currentUser = { ...user, password: '' }; // 将 password 设为空字符串
        this.originalUserData = { ...user }; // 保存原始数据
        this.passwordForm = {
          currentPassword: '',
          newPassword: '',
          confirmPassword: ''
        };
      } else {
        // 添加模式
        this.currentUser = {
          id: null,
          username: '',
          password: '',
          status: 'enabled',
          is_admin: false
        };
        this.originalUserData = null; // 重置原始数据
      }
      this.showForm = true;
    },
    validateConfirmPassword(rule, value, callback) {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入的新密码不匹配'));
      } else {
        callback();
      }
    },
    // 在 submitUser() 方法的成功回调中，判断修改的内容并显示相应的提示信息
    submitUser() {
      const formName = 'form';
      this.$refs[formName].validate((valid) => {
        if (!valid) {
          this.$message.error('请正确填写表单');
          return;
        }

        let url, method, actionSuccess, actionFail, data;
        if (this.isEditing) {
          if (this.isAdmin) {
            // 管理员编辑用户信息
            url = `${process.env.VUE_APP_API_URL}/users`;
            method = 'put';
            actionSuccess = '已修改';
            actionFail = '修改失败';

            data = { ...this.currentUser };

            // 只有当密码不为空时才提交密码
            if (!data.password) {
              delete data.password; // 如果密码为空，则删除密码字段
            }
          } else {
            // 普通用户修改自己的密码
            url = `${process.env.VUE_APP_API_URL}/users/password`;
            method = 'put';
            actionSuccess = '密码已修改';
            actionFail = '密码修改失败';

            data = {
              id: this.currentUser.id,
              current_password: this.passwordForm.currentPassword,
              new_password: this.passwordForm.newPassword
            };
          }
        } else {
          // 添加用户
          url = `${process.env.VUE_APP_API_URL}/users`;
          method = 'post';
          actionSuccess = '已添加';
          actionFail = '添加失败';

          data = { ...this.currentUser };
        }

        axios[method](url, data, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` }
        })
            .then(() => {
              this.fetchUsers();
              this.showForm = false;

              if (this.isAdmin && this.isEditing) {
                let messages = [];

                // 检查是否修改了密码
                if (this.currentUser.password) {
                  messages.push(`${this.currentUser.username} 密码已修改`);
                }

                // 检查是否修改了管理员状态
                if (this.currentUser.is_admin !== this.originalUserData.is_admin) {
                  const action = this.currentUser.is_admin ? '已授予管理员权限' : '已取消管理员权限';
                  messages.push(`${this.currentUser.username} ${action}`);
                }

                // 检查是否修改了用户状态
                if (this.currentUser.status !== this.originalUserData.status) {
                  const action = this.currentUser.status === 'enabled' ? '已启用' : '已停用';
                  messages.push(`${this.currentUser.username} ${action}`);
                }

                if (messages.length === 0) {
                  messages.push(`${this.currentUser.username} 信息未修改`);
                }

                messages.forEach(msg => this.$message.success(msg));

              } else {
                this.$message.success(`${this.currentUser.username} ${actionSuccess}`);
              }
            })
            .catch(error => {
              if (error.response && error.response.data && error.response.data.error) {
                const errorMsg = error.response.data.error;
                // 根据后端返回的错误信息，显示自定义提示
                if (errorMsg === '原密码不正确') {
                  this.$message.error(`${this.currentUser.username} 原密码不匹配`);
                } else {
                  this.$message.error(`${this.currentUser.username}: ${errorMsg}`);
                }
              } else {
                this.$message.error(`${this.currentUser.username} 用户${actionFail}`);
              }
            });
      });
    },
    toggleUserStatus(user) {
      if (!this.isAdmin) {
        this.$message.error('您没有权限修改用户状态');
        return;
      }

      if (this.isActionDisabled(user)) {
        this.$message.error('不允许修改自己的状态');
        return;
      }

      // 切换 status 的值，并确保是字符串类型
      user.status = user.status === 'enabled' ? 'disabled' : 'enabled';

      axios.put(`${process.env.VUE_APP_API_URL}/users/status`, user, {
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      })
          .then(() => {
            const action = user.status === 'enabled' ? '已启用' : '已停用';
            this.$message.success(`${user.username} ${action}`); // 去掉“用户”字样
          })
          .catch(error => {
            if (error.response && error.response.data && error.response.data.error) {
              this.$message.error(`${user.username}: ${error.response.data.error}`);
            } else {
              this.$message.error(`${user.username} 更新用户状态失败`);
            }
          });
    },
    toggleUserAdmin(user) {
      if (!this.isAdmin) {
        this.$message.error('您没有权限修改管理员权限');
        return;
      }

      if (this.isActionDisabled(user)) {
        this.$message.error('不允许修改自己的管理员权限');
        return;
      }

      // 切换管理员权限
      const newIsAdmin = !user.is_admin;

      // 发送请求更新用户的管理员权限
      axios.put(`${process.env.VUE_APP_API_URL}/users/admin`, {
        id: user.id,
        is_admin: newIsAdmin
      }, {
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      })
          .then(() => {
            // 更新本地数据
            user.is_admin = newIsAdmin;
            const action = newIsAdmin ? '已授予管理员权限' : '已取消管理员权限';
            this.$message.success(`${user.username} ${action}`);
          })
          .catch(error => {
            console.error('Failed to update user admin status:', error.response);
            if (error.response && error.response.data && error.response.data.error) {
              this.$message.error(`${user.username}: ${error.response.data.error}`);
            } else {
              this.$message.error(`${user.username} 更新管理员权限失败`);
            }
          });
    },
    handleDelete(user) {
      if (!this.isAdmin) {
        this.$message.error('您没有权限删除用户');
        return;
      }

      if (this.isActionDisabled(user)) {
        this.$message.error('不允许删除自己的账户');
        return;
      }

      this.$confirm(`此操作将永久删除用户 ${user.username}, 是否继续?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        axios.delete(`${process.env.VUE_APP_API_URL}/users/${user.id}`, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` }
        })
            .then(() => {
              this.fetchUsers();
              this.$message.success(`${user.username} 用户已删除`);
            })
            .catch(error => {
              console.error('Failed to delete user:', error.response);
              if (error.response && error.response.data && error.response.data.error) {
                this.$message.error(`${user.username}: ${error.response.data.error}`);
              } else {
                this.$message.error(`${user.username} 用户删除失败`);
              }
            });
      });
    },
    isActionDisabled(user) {
      return user.username === this.loggedInUser;
    },
    getTagStyle(isActive) {
      if (isActive) {
        return {
          color: 'rgba(64, 158, 255, 1)',                // 字体颜色，蓝色
          backgroundColor: 'rgba(64, 158, 255, 0.1)',    // 背景颜色，蓝色，透明度 0.1
          borderColor: 'rgba(64, 158, 255, 0.3)'         // 边框颜色，蓝色，透明度 0.3
        };
      } else {
        return {
          color: 'rgba(245, 108, 108, 1)',               // 字体颜色，红色
          backgroundColor: 'rgba(245, 108, 108, 0.1)',   // 背景颜色，红色，透明度 0.1
          borderColor: 'rgba(245, 108, 108, 0.3)'        // 边框颜色，红色，透明度 0.3
        };
      }
    },
  }
};
</script>


<style>
.input-with-select {
  width: 200px;
}

.header {
  margin-bottom: 20px;
}

.add-user-btn {
  background-color: transparent !important;
  color: rgba(64,158,255,0.95) !important;
  padding: 10px 20px !important;
  border-radius: 10px !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 1px 5px rgba(64,158,255,0.53) !important;
}

.add-user-btn:hover {
  background-color: rgba(64,158,255,0.95) !important;
  color: #fff !important;
  box-shadow: 0 4px 12px rgba(64,158,255,0.5);
}

.user-table-container {
  margin-top: 20px;
  background-color: #fff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.action-buttons {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center;     /* 垂直居中 */
  gap: 10px;               /* 按钮之间的间距 */
  height: 30px;
}

.el-button.is-link {
  background: transparent;
  border-color: transparent;
  color: var(--el-button-text-color);
  height: auto;
  padding: 2px;
  width: 50px;
}

/* 修改按钮的样式，使其高度和内边距一致 */
.edit-btn,
.delete-btn {
  display: flex;
  align-items: center;       /* 垂直居中图标和文字 */
  padding: 5px 10px;         /* 调整内边距 */
  font-size: 14px;           /* 统一字体大小 */
}

/* 确保按钮的图标和文字在同一行 */
.edit-btn i,
.delete-btn i {
  margin-right: 5px;
}

/* 保持原有的颜色和效果 */
.edit-btn {
  color: rgba(64, 158, 255, 0.95) !important;
  border-radius: 5px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 5px rgba(64, 158, 255, 0.53) !important;
}

.edit-btn:hover {
  color: #fff !important;
  background-color: rgba(64, 158, 255, 0.95) !important;
}

.delete-btn {
  color: #f56c6c !important;
  border-radius: 5px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 5px rgba(245, 108, 108, 0.3) !important;
}

.delete-btn:hover {
  color: #fff !important;
  background-color: #f56c6c !important;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

.el-table >>> .cell {
  box-sizing: border-box !important;
  line-height: 30px !important;
  overflow: hidden !important;
  overflow-wrap: break-word !important;
  padding: 0 12px !important;
  text-overflow: ellipsis !important;
  white-space: normal !important;
}

.clickable-status {
  cursor: pointer;
}

.clickable-admin {
  cursor: pointer;
}

.clickable-admin:hover,
.clickable-status:hover {
  opacity: 0.8;
}

</style>