<template lang="html">
  <AccountUser />
  <AccountCompany />
  <CreateProject @projectCreated="updateAccount" />
  <div id="linkToProjects">
    <card title="Check every projects!" subtitle="Hooray" :blue="true">
      <collective-button :transparent="true" @click="goToProjects">
        Check every projects!
      </collective-button>
    </card>
  </div>
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import AccountUser from '@/views/components/AccountUser.vue'
import AccountCompany from '@/views/components/AccountCompany.vue'
import CreateProject from '@/views/components/CreateProject.vue'
import CollectiveButton from '@/components/CollectiveButton.vue'
import Card from '@/components/Card.vue'
export default defineComponent({
  components: {
    AccountUser,
    AccountCompany,
    CreateProject,
    CollectiveButton,
    Card,
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ''
    const accountCompany = null
    const projectsList = null

    return { account, username, accountCompany, projectsList }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
      this.accountCompany = await contract.methods.company(address).call()
      console.log(this.projectsList)
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },

    goToProjects() {
      this.$router.push({ name: 'ProjectsList' })
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.updateAccount()
  },
})
</script>
<style lang="css" scoped>
#linkToProjects {
  padding: 24px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 500px;
  margin: auto;
}
</style>
