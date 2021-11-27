<template lang="html">
  <div v-for="projet in projectsList" :key="projet.id">
    <card :title="projet.name" subtitle="Hooray">
      <div class="explanations">
        <ul>
          <li><b>name</b>: {{ projet.name }}</li>
          <li><b>owner</b>: {{ projet.owner }}</li>
          <li><b>balance</b>: {{ projet.balance }}</li>
          <li><b>contributors</b>: {{ projet.contributors }}</li>
          <li><b>Url Git Repo</b>: {{ projet.gitAddress }}</li>
        </ul>

        On your account on the contract, you have
        {{ account.balance }} tokens. If you click
        <button class="button-link" @click="addTokens">here</button>, you can
        add some token to your account. Just give it a try! And think to put an
        eye on Ganache!
      </div>
    </card>
    <spacer :size="24" />
  </div>
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
export default defineComponent({
  name: 'ProjectsList',
  components: { Card, Spacer },
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
    const projectsList: any[] = []

    return { account, username, accountCompany, projectsList }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
      console.log(this.$refs.proj)
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
  },

  async reloadComponent() {
    const { address, contract } = this
    this.projectsList = await contract.methods.getProjects().call()
    console.log(this.$refs.proj)
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.projectsList = await contract.methods.getProjects().call()
    console.log(this.projectsList)
  },
})
</script>
<style lang="css" scoped>
/*
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}
.explanations {
  padding: 12px;
}
.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}
.input-username,
.input-projectname,
.input-companyname {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
*/
</style>
