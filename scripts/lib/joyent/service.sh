echo "Creating service '{{constants.name}}-service'..."

echo "Creating service XML at /home/{{constants.name}}/config/manifest.xml"

cat <<'EOF' > /home/{{constants.name}}/config/manifest.xml
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
<service_bundle type="manifest" name="{{constants.name}}-service">
  <service name="site/{{constants.name}}-service" type="service" version="1">

    <create_default_instance enabled="true"/>

    <single_instance/>

    <dependency name="network" grouping="require_all" restart_on="refresh" type="service">
      <service_fmri value="svc:/milestone/network:default"/>
    </dependency>

    <dependency name="filesystem" grouping="require_all" restart_on="refresh" type="service">
      <service_fmri value="svc:/system/filesystem/local"/>
    </dependency>

    <method_context working_directory="/home/{{constants.name}}/current">
      <method_credential user="admin" group="staff" privileges='basic,net_privaddr'  />
      <method_environment>
        <envvar name="PATH" value="/home/{{constants.name}}/local/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin"/>
        <envvar name="HOME" value="/home/{{constants.name}}"/>
      </method_environment>
    </method_context>

    <exec_method
      type="method"
      name="start"
      exec="/home/{{constants.name}}/local/bin/node /home/{{constants.name}}/current/run"
      timeout_seconds="60"/>

    <exec_method
      type="method"
      name="stop"
      exec=":kill"
      timeout_seconds="60"/>

    <property_group name="startd" type="framework">
      <propval name="duration" type="astring" value="child"/>
      <propval name="ignore_error" type="astring" value="core,signal"/>
    </property_group>

    <property_group name="application" type="application">

    </property_group>


    <stability value="Evolving"/>

    <template>
      <common_name>
        <loctext xml:lang="C">{{constants.name}} service</loctext>
      </common_name>
    </template>

  </service>

</service_bundle>
EOF

echo "Importing service manifest"
svccfg import /home/{{constants.name}}/config/manifest.xml

# The user should be the owner
chown -R {{constants.name}}:{{constants.name}} /home/{{constants.name}}/