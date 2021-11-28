import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },

  {
    path: '/projectslist',
    name: 'ProjectsList',
    component: () => import('@/views/ProjectsList.vue'),
  },
  {
    path: '/companieslist',
    name: 'CompaniesList',
    component: () => import('@/views/CompaniesList.vue'),
  },
  {
    path: '/bountiesList',
    name: 'BountiesList',
    component: () => import('@/views/BountiesList.vue'),
  },
  {
    path: '/createproject',
    name: 'CreateProject',
    component: () => import('@/views/CreateProject.vue'),
  },
  {
    path: '/createbounty',
    name: 'CreateBounty',
    component: () => import('@/views/CreateBounty.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
