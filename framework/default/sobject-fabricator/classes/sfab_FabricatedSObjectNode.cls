public interface sfab_FabricatedSObjectNode {
    Map<String, Object> serialize( Boolean persistable );
    void postBuildProcess( Object objectToProcess );
    String getName();
}