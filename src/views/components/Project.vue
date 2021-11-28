<template lang="html">
  <card :title="projectName" subtitle="Hooray">
    <div class="explanations">
      <ul>
        <li><b>id</b>: {{ projectId }}</li>
        <li><b>name</b>: {{ projectName }}</li>
        <li><b>owner</b>: {{ projectOwner }}</li>
        <li><b>owner status</b>: {{ createdByUser ? 'user' : 'company' }}</li>
        <li><b>contributors</b>: {{ projectContributor }}</li>
        <li><b>balance</b>: {{ projectBalance }}</li>
        <li><b>Url Git Repo</b>: {{ projectGitAddress }}</li>
        <router-link
          class="links"
          :to="{
            name: 'CreateBounty',
            params: { pid: projectId, pname: projectName },
          }"
        >
          >> Créer Bounty!
        </router-link>

        <div class="links" v-on:click="addContributor($event)">
          >> Ajoutez moi en tant que contributeur
        </div>
        <div>
          Pour créer un bounty, assurez vous d'avoir un nombre suffisant de
          token<br />Pour se mettre en contributeur, assurez vous de ne pas y
          être deja)
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
  name: 'Project',
  components: { Card },
  props: ['projet'],
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
    const projectName = ''
    const projectOwner = null
    const createdByUser = null
    const projectContributor = null
    const projectBalance = 0
    const projectGitAddress = ''
    const projectId = ''

    return {
      account,
      accountCompany,
      project,
      projectName,
      projectOwner,
      createdByUser,
      projectBalance,
      projectContributor,
      projectGitAddress,
      projectId,
    }
  },
  methods: {
    goToIndex() {
      this.$router.push({ name: 'Account' })
    },

    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      const proj = await contract.methods.getProjectById(this.projectId).call()
      if (proj != null) {
        this.project = proj
        this.projectContributor = proj.contributors
      }
    },
    goToCreateCreateBounty() {
      this.$router.push({
        name: 'CreateBounty',
        params: { pid: this.projectId },
      })
    },

    async addContributor() {
      const { contract } = this
      await contract.methods.addContributorToProject(this.projectId).send()
      this.updateAccount()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.project = this.projet
    this.projectId = this.projet[0]
    this.projectName = this.projet[1]
    this.projectOwner = this.projet[2]
    this.projectContributor = this.projet[3]
    this.projectBalance = this.projet[4]
    this.projectGitAddress = this.projet[5]
    this.createdByUser = this.projet[6]
  },
})
</script>
<style lang="css" scoped>
.links {
  color: yellowgreen;
  text-transform: uppercase;
  font-weight: 300;
  text-decoration: underline;
}
</style>
