<template lang="html">
  <!--project-->
  <div class="home">
    <form @submit.prevent="createBounty">
      <card
        title="Add a project"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
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
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
export default defineComponent({
  name: 'CreateBounty',
  components: { Card },
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

    return {
      account,
      accountCompany,
      projectsList,
      bountyName,
      bountyDesc,
      bountyReward,
      closed,
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
      const { contract, bountyName, bountyDesc, bountyReward, closed } = this
      const name = bountyName.trim().replace(/ /g, '_')
      await contract.methods
        .createBounty(bountyName, bountyDesc, bountyReward)
        .send()
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
    // console.log(this.projectsList)
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
