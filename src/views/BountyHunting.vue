<template lang="html">
  <div class="home">
    <form @submit.prevent="bountyHunting">
      <card
        title="Please fill the fields"
        subtitle="Type directly in the input and hit enter."
      >
        <div class="explanations">
          You will hunt the bounty {{ this.$route.params.name }} ( id :
          {{ this.$route.params.bid }}) with the reward :
          {{ this.$route.params.reward }}
        </div>
        <input
          type="text"
          class="input-gitUrl"
          v-model="gitUrl"
          placeholder="Type the git url"
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
  name: 'BountyHunting',
  components: { Card, PreviousPage },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },

  data() {
    const companyAccount = null
    const account = null
    const gitUrl = ''
    const bounty = null
    const bountyId = -1
    return {
      companyAccount,
      account,
      gitUrl,
      bounty,
      bountyId,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.companyAccount = await contract.methods.company(address).call()
    },
    async bountyHunting() {
      const { contract } = this
      this.gitUrl = ''
      let dd = await contract.methods.hunting(+this.bountyId).send()
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    const companyAccount = await contract.methods.company(address).call()
    if (companyAccount.name) this.companyAccount = companyAccount
    this.bountyId = +(this.$route.params.bid as string)

    this.bounty = await contract.methods.getBountyById(this.bountyId).call()

    console.log(this.bountyId)
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

.input-gitUrl {
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
