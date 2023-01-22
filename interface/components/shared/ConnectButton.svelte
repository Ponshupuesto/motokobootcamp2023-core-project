<script>
  import { plugConnection } from "../connexion"
  export let message = "Sign in"
</script>

<button on:click={() => plugConnection()}> {message} </button>

<style >
  button{
    
    font-size: 18px;
    background: rgb(9, 9, 180);
    color: #fff;
    border: none;
    padding: 10px 20px;
    display: flex;
    align-items: center;
    border-radius: 40px;
    cursor: pointer;
  }
</style>
