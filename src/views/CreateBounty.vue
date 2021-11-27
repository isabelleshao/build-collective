<template lang="html">
  <div class="home">
    <form @submit.prevent="createBounty">
      <card
        title="Add a bounty"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        for the project :

        <input
          type="text"
          class="input-bountyName"
          v-model="bountyName"
          placeholder="Type your bounty name here"
          required="required"
        />

        <input
          type="text"
          class="input-bountyDescr"
          v-model="bountyDescr"
          placeholder="Type your bounty description here"
          required="required"
        />

        <input
          type="number"
          class="input-bountyReward"
          v-model="bountyReward"
          placeholder="Type your reward here"
          min="0"
          required="required"
        />
        <input type="submit" value="Submit" class="btn" />
      </card>
    </form>
  </div>

  <PreviousPage />
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
export default defineComponent({
  name: 'CreateBounty',
  components: { Card, PreviousPage },
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
    const bountyName = ''
    const bountyDesc = ''
    const bountyReward = ''
    const closed = null
    const project = null
    const projectName = ''

    return {
      account,
      accountCompany,
      projectsList,
      bountyName,
      bountyDesc,
      bountyReward,
      closed,
      project,
      projectName,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
      console.log(this.$refs.proj)
    },

    async createBounty() {
      const { contract, bountyName, bountyDesc, bountyReward } = this
      const name = bountyName.trim().replace(/ /g, '_')
      await contract.methods.createBounty(name, bountyDesc, bountyReward).send()
      await this.updateAccount()
      this.bountyName = ''
      this.bountyDesc = ''
      this.bountyReward = ''
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
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.input-bountyName,
.input-bountyDescr,
.input-bountyReward {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.btn {
  margin: auto;
  width: 100%;
  background: rgb(89, 25, 138);
  color: white;
  font-size: 1.3rem;
}
</style>
