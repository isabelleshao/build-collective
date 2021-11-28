<template lang="html">
  <div class="home">
    <form @submit.prevent="createBounty">
      <card
        title="Create a bounty"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <div class="explanations">
          for the project id: {{ $route.params.pid }}, name :
          {{ $route.params.pname }}<br />
          Attention : le reward donné sera déduit de votre compte. Merci de bien
          verifier le solde de votre compte, sinon une exception se declenchera
        </div>
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
    const bountyName = ''
    const bountyDescr = ''
    const bountyReward = ''
    const project = null
    const bounty = null

    return {
      account,
      accountCompany,
      bountyName,
      bountyDescr,
      bountyReward,
      project,
      bounty,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.bounty = await contract.methods.bounty(address).call()
    },

    async createBounty() {
      const { contract, bountyName, bountyDescr, bountyReward } = this

      const pid = +(this.$route.params.pid as string)
      await contract.methods
        .createBounty(bountyName, bountyDescr, bountyReward, pid)
        .send()
      await this.updateAccount()
      this.bountyName = ''
      this.bountyDescr = ''
      this.bountyReward = ''
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.project = await contract.methods
      .getProjectById(+(this.$route.params.pid as string))
      .call()

    console.log(this.project)
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

.explanations {
  padding: 5px;
  font-size: 1.2rem;
  font-weight: 500;
  color: rgb(240, 240, 240);
}
</style>
