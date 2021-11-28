<template lang="html">
  <card :title="projectName" subtitle="Hooray">
    <div class="explanations">
      <ul>
        <li><b>id </b>: {{ this.b.id }}</li>
        <li><b>name</b>: {{ this.b.name }}</li>
        <li>
          <b>Bounty status</b>: {{ this.b.closed == 1 ? 'close' : 'open' }}
        </li>
        <li><b>reward</b>: {{ this.b.reward }}</li>
        <li><b>description</b>: {{ this.b.descr }}</li>
        <li><b>Created by</b>: {{ this.b.huntedBy }}</li>
        <li><b>Closed by</b>: {{ this.b.fixedBy }}</li>
        <li>for the project :{{ this.project }}</li>

        <div v-if="this.b.closed == false">
          <br />
          <router-link
            class="linkBounty"
            :to="{
              name: 'BountyHunting',
              params: {
                bid: this.b.id,
                reward: this.b.reward,
                name: this.b.name,
              },
            }"
          >
            >> Bounty Hunting!</router-link
          >
        </div>
      </ul>
    </div>
  </card>
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
export default defineComponent({
  name: 'Bounty',
  components: { Card },
  props: ['b'],
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
    const project = null
    const bounty = null

    return {
      account,
      accountCompany,
      project,
      bounty,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    const companyAccount = await contract.methods.company(address).call()
    if (companyAccount.name) this.accountCompany = companyAccount
    this.bounty = this.b
    this.project = await contract.methods
      .getProjectById(this.b.projectId)
      .call()
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

.linkBounty {
  color: white;
  padding: 10 px;
}
</style>
