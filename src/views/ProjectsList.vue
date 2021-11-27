<template lang="html">
  <div v-for="projet in projectsList" :key="projet.name">
    <card :title="projet.name" subtitle="Hooray">
      <div class="explanations">
        <ul>
          <li><b>name</b>: {{ projet.name }}</li>
          <li><b>owner</b>: {{ projet.owner }}</li>
          <li>
            <b>owner status</b>: {{ projet.createdByUser ? 'user' : 'company' }}
          </li>
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
  <PreviousPage />
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
export default defineComponent({
  name: 'ProjectsList',
  components: { Card, Spacer, PreviousPage },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const accountCompany = null
    const projectsList = null

    return { account, accountCompany, projectsList }
  },
  methods: {
    goToIndex() {
      this.$router.push({ name: 'Account' })
    },

    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
      console.log(this.$refs.proj)
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.projectsList = await contract.methods.getProjects().call()
  },
})
</script>
<style lang="css" scoped>
.links {
  padding: 24px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 500px;
  margin: auto;
}
</style>
