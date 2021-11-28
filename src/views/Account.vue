<template lang="html">
  <AccountUser @update="account = $event" />
  <AccountCompany @update="accountCompany = $event" v-if="account" />
  <div class="tab">
    <div class="links" v-if="account">
      <card title="Create a  project!" subtitle="Hooray" :blue="true">
        <collective-button :transparent="true" @click="goToCreateProject">
          Create a project!
        </collective-button>
      </card>
    </div>

    <div class="links" v-if="account">
      <card title="Check every projects!" subtitle="Hooray" :blue="true">
        <collective-button :transparent="true" @click="goToProjects">
          Check every projects!
        </collective-button>
      </card>
    </div>

    <div class="links" v-if="account">
      <card title="Check every companies!" subtitle="Hooray" :blue="true">
        <collective-button :transparent="true" @click="goToCompanies">
          Check every companies!
        </collective-button>
      </card>
    </div>

    <div class="links" v-if="account">
      <card title="Fix!" subtitle="Hooray" :blue="true">
        <collective-button :transparent="true" @click="goToBounties">
          Check every bounties!
        </collective-button>
      </card>
    </div>
  </div>
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import AccountUser from '@/views/components/AccountUser.vue'
import AccountCompany from '@/views/components/AccountCompany.vue'
import CollectiveButton from '@/components/CollectiveButton.vue'
import Card from '@/components/Card.vue'
export default defineComponent({
  components: {
    AccountUser,
    AccountCompany,
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
    goToCreateProject() {
      this.$router.push({ name: 'CreateProject' })
    },
    goToProjects() {
      this.$router.push({ name: 'ProjectsList' })
    },

    goToCompanies() {
      this.$router.push({ name: 'CompaniesList' })
    },

    goToBounties() {
      this.$router.push({ name: 'BountiesList' })
    },
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
.links {
  padding: 24px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 500px;
  margin: auto;
}
</style>
