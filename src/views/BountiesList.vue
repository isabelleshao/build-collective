<template lang="html">
  <div v-for="b in bountiesList" :key="b.name">
    <Bounty :b="b" />
    <spacer :size="24" />
  </div>
  <PreviousPage />
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Spacer from '@/components/Spacer.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
import Bounty from '@/views/components/Bounty.vue'
export default defineComponent({
  name: 'BountiesList',
  components: { Spacer, PreviousPage, Bounty },
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
    const bountiesList = null

    return { account, accountCompany, bountiesList }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
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
    this.bountiesList = await contract.methods.getBounties().call()
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
